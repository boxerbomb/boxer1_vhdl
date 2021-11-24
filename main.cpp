#include <iostream>
#include <iomanip>

#include <bitset>


//Read lomne by lime
#include <sstream>
#include <string>
//--------------

#define UNUSED_VAL 4294967295

enum inst_type {U_TYPE, J_TYPE, I_TYPE, B_TYPE, S_TYPE, R_TYPE,BREAK_TYPE};
const char *type_words[]{
    "U_TYPE",
    "J_TYPE",
    "I_TYPE",
    "B_TYPE",
    "S_TYPE",
    "R_TYPE"
    "BREAK_TYPE"
};


class decoded_inst{
    public:
        decoded_inst(unsigned int instruction_in){
            my_type = BREAK_TYPE;
            rs1 = UNUSED_VAL;
            rs2 = UNUSED_VAL;
            rd = UNUSED_VAL;
            csr = UNUSED_VAL;
            opcode = UNUSED_VAL;
            imm = UNUSED_VAL;
            func7 = UNUSED_VAL;
            func3= UNUSED_VAL;
            instruction = instruction_in;

            process_inst();
        }

        inst_type get_type(){
            return my_type;
        }

        bool process_inst(){
            //Grab obcode from bit 6 downto 0
            opcode = get_bits(6,0);

            // Instruction Encoding depends on the instruction type.
            switch(opcode){
                case 0x33:
                    // add, sub, slr, sll, xor, or, sra, and
                    my_type = R_TYPE;
                    func7 = get_bits(31, 25);
                    rs2 = get_bits(24, 20);
                    rs1 = get_bits(19,15);
                    func3 = get_bits(14,12);
                    rd = get_bits(11,7);
                    break;
                case 0x03:
                    // lb, lh, lw, lbu, lhu
                    my_type = I_TYPE;
                    imm = get_bits( 31, 20);
                    rs1 = get_bits(19,15);
                    func3 = get_bits(14,12);
                    rd = get_bits(11, 7);
                    break;
                case 0x13:
                    // addi, slli, xori, srai, srai, srli, ori, andi
                    my_type = I_TYPE;
                    imm = get_bits( 31, 20);
                    rs1 = get_bits(19,15);
                    func3 = get_bits(14,12);
                    rd = get_bits(11, 7);
                    break;
                case 0x23:
                    //sb, sh, sw
                    my_type = S_TYPE;
                    // Double Check this logic
                    imm = (get_bits(31,25)<<5) + (get_bits(11,7));
                    rs2=get_bits(24,20);
                    rs1 = get_bits(19,15);
                    func3= get_bits(14,12);
                    break;
                case 0x63:
                    //beq, bne, blt, bge, bltu, bgeu
                    my_type = B_TYPE;
                    //Check this math, note, last bit is always 0
                    imm=(get_bits(31,31)<<12)+(get_bits(7,7)<<11)+(get_bits(30,25)<<5)+(get_bits(11,8)<<1);
                    rs2 = get_bits(24,20);
                    rs1 = get_bits(19,15);
                    func3 = get_bits(14,12);
                    break;
                case 0x37:
                    //lui
                    my_type = U_TYPE;
                    imm = get_bits(31,12);
                    rd = get_bits(11,7);
                    break;
                case 0x67:
                    //jalr
                    my_type = I_TYPE;
                    imm = get_bits( 31, 20);
                    rs1 = get_bits(19,15);
                    func3 = get_bits(14,12);
                    rd = get_bits(11, 7);
                    break;
                case 0x6F:
                    //jal
                    my_type = J_TYPE;
                    // Note bit 0 is always 0
                    imm = (get_bits(31,31)<<20)+(get_bits(19,12)<<12)+(get_bits(20,20)<<11)+(get_bits(30,21)<<1);
                    rd = get_bits(11,7);
                    break;
                case 0x17:
                    //auipc
                    my_type = U_TYPE;
                    imm = get_bits(31,12);
                    rd = get_bits(11,7);
                    break;
                default:
                    std::cout<<"Error Decoding, keep at break"<<std::endl;
                    my_type = BREAK_TYPE;
            }


            return true;
        }

        void print_info(){
            std::cout<<"\n--------------------------------------------\n";
            std::cout<<"Type: "<<type_words[my_type]<<std::endl;
            if (opcode != UNUSED_VAL) std::cout<<"Opcode: 0x"<<std::hex<<opcode<<std::endl;
            if (imm != UNUSED_VAL) std::cout<<"Imm: 0x"<<std::hex<<imm<<std::endl;
            if (imm != UNUSED_VAL) std::cout << "Imm = " << std::bitset<32>(imm)  << std::endl;
            if (rs1 != UNUSED_VAL) std::cout<<"rs1: 0x"<<std::hex<<rs1<<std::endl;
            if (rs2 != UNUSED_VAL) std::cout<<"rs2: 0x"<<std::hex<<rs2<<std::endl;
            if (rd != UNUSED_VAL) std::cout<<"rd: 0x"<<std::hex<<rd<<std::endl;
            if (csr != UNUSED_VAL) std::cout<<"csr: 0x"<<std::hex<<csr<<std::endl;
            if (func7 != UNUSED_VAL) std::cout<<"func7: 0x"<<std::hex<<func7<<std::endl;
            if (func3 != UNUSED_VAL) std::cout<<"func3: 0x"<<std::hex<<func3<<std::endl;
            std::cout<<"--------------------------------------------\n";
        }
    private: 
        unsigned int instruction;
        inst_type my_type;
        unsigned int rs1;
        unsigned int rs2;
        unsigned int rd;
        unsigned int csr;
        unsigned int opcode;
        unsigned int imm;
        unsigned int func7;
        unsigned int func3;

        //Numbered as 31,30,29,...,2,1,0
        unsigned int get_bits(int high_bit, int low_bit){
            unsigned int mask;
            mask = ((1 << (high_bit-low_bit+1)) - 1) << low_bit;

            //Used for debugging with #include <bitset>
            //std::cout << "data = " << std::bitset<32>(data)  << std::endl;
            //std::cout << "mask = " << std::bitset<32>(mask)  << std::endl;
            //std::cout << "eval = " << std::bitset<32>((data&mask)>>low_bit)  << std::endl;
            return (instruction & mask)>>low_bit;
        }
};


int main(int argc, char *argv[])
{   
    /*
        Demo Values

    00011110001001000000101010110111 U-type imm=0x1E240 rd=0x15  
    01001000000000111100101011101111 J_type imm=0x3C480 rd=0x15
    10101010101010101011101010010011 I_type imm=0x2730 rs1=0x15 func3=0x3 rd=0x15
    11010101010110101001101001100011 B_type imm=0x1554 rs2=0x15 rs1=0x15 func3=0x1 
    10110000010111111001101110100011 S_type imm=0xB17  rs2=0x5 rs1=0x1f func3=0x1 rd=0x17
    01000001101100110011110010110011 R_type func7=0x20 rs2=0x1B rs1=0x6 func3=0x3 rd=19
    */

    decoded_inst test0(505678519);
    test0.print_info();

    decoded_inst test1(1208208111);
    test1.print_info();

    decoded_inst test2(2863315603);
    test2.print_info();

    decoded_inst test3(3579484771);
    test3.print_info();

    decoded_inst test4(2959055779);
    test4.print_info();

    decoded_inst test5(1102265523);
    test5.print_info();    

    ifstream infile;
    infile.open ("file.txt");

    std::string line;
    while (std::getline(infile, line))
    {
        std::istringstream iss(line);
        std::cout<<line<<std::endl
    }



    

}
