// {{{ GPL License

// This file is part of clingo.
// Copyright (C) 2016  Benjamin Kaufmann

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// }}}

#ifndef PIGEON_PP_HH
#define PIGEON_PP_HH

#include "clingo/clingocontrol.hh"
#include <unordered_map>
#include <vector>

class PigeonPropagator : public Gringo::Propagator {
public:
    virtual void init(Init &init) override;
    virtual void propagate(Potassco::AbstractSolver& solver,  const ChangeList& changes) override;
    virtual void undo(const Potassco::AbstractSolver& solver, const ChangeList& undo) override;
    virtual void check(Potassco::AbstractSolver& solver) override;
private:
    using Lit2Hole = std::unordered_map<Potassco::Lit_t, unsigned>;
    using Hole2Lit = std::vector<Potassco::Lit_t>;
    using State    = std::vector<Hole2Lit>;
    
    Lit2Hole p2h_;
    State    state_;
};

#endif

