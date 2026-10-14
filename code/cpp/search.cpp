// Primal search for cardinality colourings: find a placed weighted poset (base b,
// elements added as maximal elements) with at least K down-sets whose sizes
// b + w(D) all have one colour.  Used by python/cegar.py.
#include <bits/stdc++.h>
using namespace std;
typedef unsigned long long ull;
int n,K; vector<char> inS; // inS[x] for x in 0..n
struct DS{unsigned mask;int sum;}; vector<pair<unsigned,int>> elts;
vector<DS> ds; int nel; int b;
vector<int> witT;
bool dfs(){
  if((int)ds.size()>=K) return true;
  if(nel>=K-1) return false;
  int cur=ds.size();
  for(int d=0; d<cur; d++){
    unsigned D=ds[d].mask;
    vector<int> sup;
    for(int e=0;e<cur;e++) if((ds[e].mask&D)==D) sup.push_back(e);
    int maxs=0; for(int e:sup) maxs=max(maxs,ds[e].sum);
    for(int w=1; b+maxs+w<=n; w++){
      bool ok=true;
      for(int e:sup) if(!inS[b+ds[e].sum+w]){ok=false;break;}
      if(!ok) continue;
      for(int e:sup) ds.push_back({ds[e].mask|(1u<<nel), ds[e].sum+w});
      nel++; elts.push_back({D,w});
      if(dfs()) return true;
      nel--; elts.pop_back(); ds.resize(cur);
    }
  }
  return false;
}
// returns true and fills T (set of sizes) if found
bool find(const vector<char>& S, int nn, int KK, vector<int>& T){
  n=nn;K=KK;inS=S;
  for(b=0;b<=n;b++){ if(!inS[b]) continue; ds.clear(); elts.clear(); ds.push_back({0,0}); nel=0;
    if(dfs()){ set<int> t; for(auto&x:ds) t.insert(b+x.sum); T.assign(t.begin(),t.end()); return true;} }
  return false;
}
int main(int argc,char**argv){
  // read lines: n K string(R/B of length n+1); output witness for each colour
  string line;
  while(getline(cin,line)){
    istringstream is(line); int nn,KK; string g; is>>nn>>KK>>g;
    vector<int> T; bool any=false;
    for(char c: string("RB")){
      vector<char> S(nn+1); for(int i=0;i<=nn;i++) S[i]=(g[i]==c);
      if(find(S,nn,KK,T)){ cout<<c<<' '<<b<<' '<<elts.size(); for(auto&e:elts) cout<<' '<<e.first<<' '<<e.second; cout<<" |"; for(int x:T) cout<<' '<<x; cout<<"\n"; any=true; break; }
    }
    if(!any) cout<<"OK\n";
    cout.flush();
  }
}
