#ifndef MYCONVERSIONS_H_
#define MYCONVERSIONS_H_

#include <compact_lang_det.h>
#include <EXTERN.h>
#include <perl.h>
#include <vector>


void hashref_to_cldhint(pTHX_ SV *hashref, CLD2::CLDHints *cldhints);

HV *resultchunk_to_hash(pTHX_ const CLD2::ResultChunk &rc);

AV *resultchunk_vector_to_array(pTHX_ const std::vector<CLD2::ResultChunk> &rcv);

#endif
