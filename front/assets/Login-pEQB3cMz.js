import{j as e,G as n,B as t}from"./mui-libs-tE8MvhFN.js";import{r as i}from"./react-libs-idFwDLyp.js";import{i as r,U as o,M as s}from"./index-8I-A2yiH.js";import{A as a,l as c}from"./login-bg-i6BRDP2F.js";const l={pageContainer:{flexGrow:1},leftContainer:{backgroundSize:"cover",backgroundPosition:"center"},loginLogo:{width:240},formContainer:{height:"100vh",backgroundSize:"cover",backgroundPosition:"center"},userTypeButton:{color:"#fff",textTransform:"capitalize",fontWeight:400,borderRadius:0,fontSize:12,minWidth:"160px",margin:"16px"},whiteOverlay:{position:"absolute",top:0,left:0,width:"100%",height:"100%",backgroundColor:"#fff",opacity:.2}},d=()=>{const{T:d}=r(),{setUser:m}=i.useContext(o);return e.jsx(a,{children:e.jsxs(n,{container:!0,direction:"row",justifyContent:"center",alignItems:"center",sx:l.pageContainer,children:[e.jsx(n,{container:!0,md:6,direction:"column",justifyContent:"center",alignItems:"center",sx:{...l.leftContainer,height:{md:"100vh",sm:0},backgroundImage:{md:`url(${c})`}}}),e.jsxs(n,{md:6,xs:12,container:!0,direction:"column",justifyContent:"center",alignItems:"center",sx:{...l.formContainer,backgroundImage:{md:"none",xs:`url(${c})`}},children:[e.jsx("div",{style:l.whiteOverlay}),e.jsx(n,{container:!0,direction:"row",justifyContent:"center",alignItems:"center",children:e.jsx(s,{})}),e.jsx(n,{container:!0,direction:"row",justifyContent:"center",alignItems:"center",children:e.jsx(n,{children:e.jsx(t,{disableElevation:!0,onClick:()=>m({name:"administrator",isAuthenticated:!0}),sx:l.userTypeButton,variant:"contained",color:"primary",size:"large",children:d("login")})})})]})]})})};export{d as default};