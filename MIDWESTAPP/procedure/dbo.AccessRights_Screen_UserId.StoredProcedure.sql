USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[AccessRights_Screen_UserId]    Script Date: 12/21/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[AccessRights_Screen_UserId] @ScrnNbr varchar(5), @UserId varchar(24)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS

SELECT CONVERT(varchar(10),COALESCE(MAX(seclevel),0)) FROM
(select vc.cpnyname,
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
where isnull(nullif(va.companyid,'[ALL] '),vc.cpnyid) = vc.cpnyid
--and va.userid = @UserId
and substring(va.screennumber ,1,5)= @ScrnNbr
group by cpnyname,vc.databasename,active,cpnyid, screennumber,coalesce(vg.userid,va.userid)
) as m

where m.userid = @Userid and m.scrn = @scrnNbr
GO
