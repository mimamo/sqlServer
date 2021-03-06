USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjbillch_spk3f]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjbillch_spk3f] @parm1 varchar (1) , @parm2 varchar (10) , @parm3 varchar (24) , @parm4 varchar (16)  as
select * from pjbillch, pjbill, pjproj
where pjbillch.project =    pjbill.project
and pjbillch.project   =    pjproj.project
and pjbillch.status    =    @parm1
and pjbill.biller      like @parm2
and pjproj.gl_subacct  like @parm3
and pjbillch.project   like @parm4
order by
pjbillch.project,
pjbillch.appnbr
GO
