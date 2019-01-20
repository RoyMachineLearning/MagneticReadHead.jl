module MagneticReadHead

using Cassette
using MacroTools


export set_breakpoint, @iron_debug


Cassette.@context MagneticCtx;

include("utils.jl")
include("inner_repl.jl")
include("break_action.jl")
include("breakpoints.jl")

macro iron_debug(body)
    quote
        ctx = MagneticCtx()
        Cassette.recurse(ctx, ()->$(esc(body)))
    end
end


end # module
