#include <iostream>
#include <verilated.h>
#include "Vstoper.h"

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);
    Vstoper stp;

    stp.rst = 1;
    stp.eval();
    stp.rst = 0;

    for (int time = 0; time < 16000; time++) 
    {
        stp.clk = time & 1;
        stp.eval();

        if(stp.clk)
        {
            for(int i = 3; i >= 0; i--)
                std::cout << (((int)stp.num >> (i*4)) & 0x0f) << (i == 2 ? ":" : "");
            std::cout << std::endl;
        }
    }
}