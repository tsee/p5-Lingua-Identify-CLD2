#include <stdio.h>
#include "myconversions.h"
#include <encodings.h>

using namespace CLD2;

void
hashref_to_cldhint(pTHX_ SV *hashref, CLDHints *cldhints)
{
  if (!SvOK(hashref)) {
    // Special case: If undef, we'll use defaults.
    cldhints->content_language_hint = NULL;
    cldhints->tld_hint              = NULL;
    cldhints->encoding_hint         = UNKNOWN_ENCODING;
    cldhints->language_hint         = UNKNOWN_LANGUAGE;
    return;
  }

  if (!SvROK(hashref) || SvTYPE(SvRV(hashref)) != SVt_PVHV)
    croak("Need hashref for CLDHints");
  
  HV *hv = (HV *)SvRV(hashref);

  SV **svp;

  svp = hv_fetchs(hv, "content_language_hint", 0);
  cldhints->content_language_hint = (svp && SvOK(*svp)) ? SvPV_nolen(*svp) : NULL;

  svp = hv_fetchs(hv, "tld_hint", 0);
  cldhints->tld_hint = (svp && SvOK(*svp)) ? SvPV_nolen(*svp) : NULL;

  svp = hv_fetchs(hv, "encoding_hint", 0);
  cldhints->encoding_hint = (svp && SvOK(*svp)) ? SvIV(*svp) : UNKNOWN_ENCODING;

  svp = hv_fetchs(hv, "language_hint", 0);
  cldhints->language_hint = (svp && SvOK(*svp)) ? (Language)SvIV(*svp) : UNKNOWN_LANGUAGE;
}

HV *
resultchunk_to_hash(pTHX_ const ResultChunk &rc)
{
  HV *hv = newHV();

  hv_stores(hv, "offset", newSViv(rc.offset));
  hv_stores(hv, "bytes", newSViv(rc.bytes));
  hv_stores(hv, "lang1", newSVuv(rc.lang1));
  hv_stores(hv, "pad", newSVuv(rc.pad));

  return hv;
}

AV *
resultchunk_vector_to_array(pTHX_ const std::vector<ResultChunk> &rcv)
{
  AV *av = newAV();

  const unsigned int n = rcv.size();
  for (unsigned int i = 0; i < n; ++i) {
    HV *hv = resultchunk_to_hash(aTHX_ rcv[i]);
    av_push(av, newRV_noinc((SV *)hv));
  }

  return av;
}
