USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vs_share_secCpny]    Script Date: 12/21/2015 16:12:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vs_share_secCpny]
as

select vc.cpnyname,
       vc.databasename,
       vc.active,
       vc.cpnyid cpnyid,
       substring(screennumber,1,5) scrn,
       coalesce(vg.userid,va.userid) userid,
       convert(char,max(viewrights + updaterights + insertrights + deleterights + initrights)) seclevel
  from vs_company vc,
       vs_accessdetrights va
    
       left outer join vs_usergrp vg 
       on   
       vg.groupid = va.userid and va.rectype = 'G'                 
       where  isnull(nullif(va.companyid,'[ALL] '),vc.cpnyid) = vc.cpnyid
       group by cpnyname,vc.databasename,active,cpnyid, screennumber,coalesce(vg.userid,va.userid)
GO
