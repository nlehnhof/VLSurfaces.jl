module VLSurfaces

# Write your package code here.
using VortexLattice


# Take the basic surface already created -- wing, horizontal stabilizer, vertical stabilizer
function create_basic_surface(xle::list, yle::list, zle::list, chord::list, ns::Int, nc::Int, spacing_s, spacing_c, mirror::Bool)
    len = length(chord)
    theta = (2.0*pi/180) * ones(len)
    phi = zeros(len)
    fc = fill((xc) -> 0, len)
    ns = length(chord) - 1
    nc = 6
    return chord, xle, yle, zle, theta, phi, fc, ns, nc, spacing_s, spacing_c, mirror
end


# yle_root, yle_tail, xle_root, xle_tail must be index numbers of yle and xle
function create_control_surface(yle_dist::Float64, yle_root::Int, yle_tail::Int, xle_root::Int, xle_tail::Int, xle::list, yle::list, zle::list, chord::list, theta::list, phi::list, fc, ns::int, nc::int, spacing_s, spacing_c, mirror::Bool)
    # Initialize
    len = length(chord)

    # yle_root and yle_tail define at what semi-span position the control surface begins and ends
    # xle_root and xle_tail define at what chord position the control surface begins and ends
    # yle_dist is the distance of the control surface from the leading edge of the surface at its root position

    # Since each yle corresponds to a ns value 
    chord_c = xle[xle_root: xle_tail] .+ chord[yle_root:yle_tail] .- yle_dist
    xle_c = yle_dist * length(chord_c)
    yle_c = yle[yle_root:yle_tail]
    zle_c = zle[yle_root:yle_tail] 
    theta_c = (2.0*pi/180) * ones(len)
    phi_c = zeros(length(chord_c))
    fc_c = fill((xc) -> 0, length(chord_C))
    ns_c = length(chord_c) - 1
    ns_c = 3
    spacing_sc = spacing_s
    spacing_cc = spacing_c
    mirror_c = mirror 

    return chord_c, xle_c, yle_c, zle_c, theta_c, phi_c, fc_c, ns_c, nc_c, spacing_sc, spacing_cc, mirror_c
end



end
