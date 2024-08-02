# module VLSurfaces

# Write your package code here.
using VortexLattice

# wing
chord1 = [0.2995841993843728, 0.29623678483095345, 0.289425833365632, 0.2788977115682478, 0.26420842943181333, 0.24460947449731052, 0.21878536516659502, 0.18413532299511476, 0.1339781269616617, 0.01]
xle1 = (chord1[1] / 2) .- (chord1 ./ 2)
yle1 = range(0.0, 0.75, length(chord1))
zle1 = zeros(length(chord1))

# Reference Values
Sref = 0.5
cref = 0.2
bref = 1.5
rref = [0.5, 0.0, 0.0]
Vinf = 1.0
ref = Reference(Sref, cref, bref, rref, Vinf)
rho = 1.02

alpha = 5.0*pi/180
beta = 0.0
Omega = [0.0; 0.0; 0.0]
fs = Freestream(Vinf, alpha, beta, Omega)

symmetric = [false, false]


# Take the basic surface already created -- wing, horizontal stabilizer, vertical stabilizer, etc.

function create_basic_surface(xle::Vector, yle::Vector, zle::Vector, chord::Vector)
    len = length(chord)
    theta = (2.0*pi/180) * ones(len)
    phi = zeros(len)
    fc = fill((xc) -> 0, len)
    ns = length(chord) - 1
    nc = 6
    mirror = true
    spacing_s = Uniform()
    spacing_c = Uniform()
    return chord, xle, yle, zle, theta, phi, ns, nc, mirror, fc, spacing_s, spacing_c
end


# yle_root, yle_tail, xle_root, xle_tail must be index numbers of yle and xle
# Create control surface and make surface panels

function create_control_surface(yle_dist::Float64, yle_root::Int, yle_tail::Int, xle_root::Int, xle_tail::Int, xle::Vector, yle::Vector, zle::Vector, chord::Vector, theta::Vector, phi::Vector, fc, ns::Int, nc::Int, spacing_s, spacing_c, mirror::Bool)
    
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

    cgrid, control = wing_to_surface_panels(xle_c, yle_c, zle_c, chord_c, theta_c, phi_c, ns_c, nc_c;
    mirror=mirror_c, fc = fc_c, spacing_s=spacing_sc, spacing_c=spacing_cc)

    return chord_c, xle_c, yle_c, zle_c, theta_c, phi_c, fc_c, ns_c, nc_c, spacing_sc, spacing_cc, mirror_c, cgrid, control
end


# update original surface and make surface panels

function update_original_surface()
    chord, xle, yle, zle, theta, phi, fc, ns, nc, spacing_s, spacing_c, mirror = create_basic_surface(xle, yle, zle, chord, ns, nc, spacing_s, spacing_c, mirror)
    yle_dist_c, yle_root_c, yle_tail_c, xle_root_c, xle_tail_c, xle_c, yle_c, zle_c, chord_c, theta_c, phi_c, fc_c, ns_c, nc_c, spacing_sc, spacing_cc, mirrror_c, cgrid, control = create_control_surface(yle_dist, yle_root, yle_tail, xle_root, xle_tail, xle, yle, zle, chord, theta, phi, fc, ns, nc, spacing_s, spacing_c, mirrror)

    chord_up = []
    append!(chord_up, chord[1:yle_root_c])
    append!(chord_up, chord_c)
    append!(chord_up, chord[yle_tail_c:end])

    mgrid, main = wing_to_surface_panels(xle, yle, zle, chord_up, theta, phi, ns, nc;
    mirror=mirror, fc = fc, spacing_s=spacing_s, spacing_c=spacing_c)

    return mgrid, main, cgrid, control
end


create_basic_surface(xle1, yle1, zle1, chord1)

# end
