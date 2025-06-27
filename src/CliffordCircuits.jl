using QuantumClifford

@enum PauliType begin
    PauliX = 1
    PauliY = 2    
    PauliZ = 3
end


function bit_string_i(i::Integer, n::Integer)
    str = zeros(Bool, n);
    str[i] = true;
    return str
end

function bit_string_ij(i::Integer, j::Integer, n::Integer)
    @assert(i != j);
    str = zeros(Bool, n);
    str[i] = true;
    str[j] = true;
    return str
end

function bit_string_from_indices(indices::Vector{<:Integer}, n::Integer)
    str = zeros(Bool, n);
    for i in indices
        str[i] = true;
    end
    return str
end


function pauli_from_bits(t::PauliType, bits::Vector{Bool}, n::Integer)
    if t == PauliX::PauliType
        return PauliOperator(0x0, bits, zeros(Bool, n));
    elseif t == PauliZ::PauliType 
        return PauliOperator(0x0, zeros(Bool, n), bits); 
    else
        return PauliOperator(0x0, bits, bits);
    end
end

pauli_from_indices(t::PauliType, indices::Vector{<:Integer}, n::Integer) = pauli_from_bits(t, bit_string_from_indices(indices, n), n)
pauli_i(t::PauliType, i::Integer, n::Integer) = pauli_from_bits(t, bit_string_i(i, n), n);
pauli_ij(t::PauliType, i::Integer, j::Integer, n::Integer) = pauli_from_bits(t, bit_string_ij(i, j, n), n);
pauli_ij(ti::PauliType, tj::PauliType, i::Integer, j::Integer, n::Integer) = pauli_i(ti, i, n) * pauli_i(tj, j, n);
