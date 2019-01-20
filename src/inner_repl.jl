"""
    argnames(f, args)

For a function `f` with the arguments `args`
returns a dict mapping the names of the arguments to their values.
"""
function argnames(f, args)
    meth = only(methods(f, typeof.(args)))
    names = Base.method_argnames(meth)[2:end] # first is self

    return Dict(zip(names, args))
end

subnames(name2arg, x::Any) = x # fallback, for literals
subnames(name2arg, name::Symbol) = get(name2arg, name, name)
function subnames(name2arg, code::Expr)
    MacroTools.postwalk(code) do name
        # TODO Make this handle the name being on the LHS of assigment right
        get(name2arg, name, name)  # If we have a value for it swap it in. 
    end
end


###############

function get_user_input(io=stdin)
    printstyled("iron>"; color=:light_red)
    
    ast = nothing
    line = ""
    while true
        # Very cut down REPL input code
        # https://github.com/JuliaLang/julia/blob/b8c0ec8a0a2d12533edea72749b37e6089a9d163/stdlib/REPL/src/REPL.jl#L237
        line *= readline(io)
        ast = Base.parse_input_line(line)
        ast isa Expr && ast.head == :incomplete || break
    end
    return ast
end

