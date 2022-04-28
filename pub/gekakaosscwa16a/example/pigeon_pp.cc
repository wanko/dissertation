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

#include "pigeon_pp.hh"
#include <stdio.h>
using Potassco::Lit_t;

void PigeonPropagator::init(Init &init) {
    unsigned nHole = 0, nPig = 0, nWatch = 0, p, h;
    state_.clear();
    p2h_[0] = 0;
    for (auto&& domain = init.getDomain().iter(Gringo::Signature("place", 2)); domain.get(); domain = domain->next()) {
        Lit_t lit = init.mapLit(domain->literal());
        p = domain->atom().args()[0].num();
        h = domain->atom().args()[1].num();
        p2h_[lit] = h;
        init.addWatch(lit);
        nHole = std::max(h, nHole);
        nPig  = std::max(p, nPig);
        ++nWatch;
    }
    assert(p2h_[0] == 0);
    printf("Initializing Pigeon Propagator: Pigeons=%u Holes=%u Watches=%u\n", nPig, nHole, nWatch);
    for (unsigned i = 0, end = init.threads(); i != end; ++i) {
        state_.emplace_back(nHole + 1, 0);
        assert(state_.back().size() == nHole + 1);
    }
}
void PigeonPropagator::propagate(Potassco::AbstractSolver& solver, const ChangeList& changes) {
    assert(solver.id() < state_.size());
    Hole2Lit& holes = state_[solver.id()];
    for (Lit_t lit : changes) {
        Lit_t& prev = holes[ p2h_[lit] ];
        if (prev == 0) { prev = lit; }
        else {
            Lit_t clause[2] = {-lit, -prev};
            if (!solver.addClause(Potassco::toSpan(clause, 2)) || !solver.propagate()) {
                return;
            }
            assert(false);
        }
    }
}
void PigeonPropagator::undo(const Potassco::AbstractSolver& solver, const ChangeList& undo) {
    assert(solver.id() < state_.size());
    Hole2Lit& holes = state_[solver.id()];
    for (Lit_t lit : undo) {
        unsigned hole = p2h_[lit];
        if (holes[hole] == lit) {
            holes[hole] = 0;
        }
    }
}
void PigeonPropagator::check(Potassco::AbstractSolver&) {}

