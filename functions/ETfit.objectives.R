# --------------------------------------------------
# hydromad objective functions
# Satellite Hydromad
# Willem Vervoort/Joseph Guillaume
# September 2015
# -------------------------------

# use Viney's objective function(includes Bias), to fit 
# see http://hydromad.catchment.org/#hydromad.stats
hydromad.stats("viney" = function(Q, X, ...) {
  hmadstat("r.squared")(Q, X, ...) -
    5*(abs(log(1+hmadstat("rel.bias")(Q,X)))^2.5)})

# This is one way to do this, but uses the NSE
# Define an objective function that aggregates ET based on specified periods
# use buildTsObjective, but this uses the NSE
hydromad.stats("ETfun" = function(...,DATA,U) {
  .(buildTsObjective(DATA$aET, groups=DATA$et.period, 
                     FUN=sum))(DATA$aET,U$ET,...)})

# Also define an objective function that aggregates ET and fits
# # Use buildTsObjective to create a new objective function
# Define an objective function that aggregates ET based on specified periods
hydromad.stats("ETaggrViney" = function(..., DATA,U) {
  #This should be mean if the observed aET is repeated for each point in the period
  # using sum because inserted 0 values in data (ETa.merge)
  # inserted "coredata" statement after discussion with J Guillaume
  # relates to how bias is calculated
  aET.fin <- aggregate(DATA$aET,list(date=coredata(DATA$et.period)),sum)
  ET.fin <- aggregate(U$ET,list(date=coredata(DATA$et.period)),sum)
  #This can be any objective function
  obj <- hmadstat("viney")(coredata(aET.fin),coredata(ET.fin))
  return(obj)
})
