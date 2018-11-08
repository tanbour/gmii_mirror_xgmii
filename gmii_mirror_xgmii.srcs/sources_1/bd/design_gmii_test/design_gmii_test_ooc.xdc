################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name PHY2_RX_CLK -period 8 [get_ports PHY2_RX_CLK]
create_clock -name default_sysclk_250_clk_p -period 4 [get_ports default_sysclk_250_clk_p]

################################################################################