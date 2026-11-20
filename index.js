export default {
 async fetch(request, env) {
  const url = new URL(request.url);
  if (url.pathname === "/api/status") {
   const rows = await env.DB.prepare("SELECT source,status,last_success_utc,message FROM source_health ORDER BY source").all();
   return json({status:"online",data_status:rows.results?.length?"SOURCE CHECKS RECORDED":"NO VERIFIED DATA YET",sources:rows.results||[]});
  }
  if (url.pathname === "/api/predictions") {
   const rows = await env.DB.prepare(
    "SELECT horizon,expected_price,lower_price,upper_price,p_up,p_down,p_sideways,confidence_label,direction,created_at_utc,model_version FROM forecasts WHERE instrument='IBJA_22K_INR_G' ORDER BY created_at_utc DESC LIMIT 3"
   ).all();
   const latest={}; for (const r of (rows.results||[])) if(!latest[r.horizon]) latest[r.horizon]=r;
   const forecasts={};
   for(const [k,r] of Object.entries(latest)) forecasts[k]={
    expected_inr_per_gram:r.expected_price,lower_inr_per_gram:r.lower_price,upper_inr_per_gram:r.upper_price,
    p_up:r.p_up,p_down:r.p_down,p_sideways:r.p_sideways,confidence_label:r.confidence_label,direction:r.direction
   };
   return json({model_version:rows.results?.[0]?.model_version||"PR-HYBRID-0.1",as_of_ist:rows.results?.[0]?.created_at_utc||null,forecasts,disclaimer:"Research estimates only; not financial advice. Confidence is uncalibrated until walk-forward validation."});
  }
  return json({error:"Not found"},404);
 }
};
function json(data,status=200){return new Response(JSON.stringify(data),{status,headers:{"content-type":"application/json; charset=utf-8","cache-control":"no-store","access-control-allow-origin":"*"}});}
