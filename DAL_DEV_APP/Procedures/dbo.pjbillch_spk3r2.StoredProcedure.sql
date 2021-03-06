USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjbillch_spk3r2]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjbillch_spk3r2] @parm1 varchar (10) , @parm2 varchar (10) , @parm3 varchar (24) , @parm4beg varchar (16) , @parm4end varchar (16) , @parm5 varchar (6)  as
select COUNT(*) from pjbillch, pjbill, pjproj
where    pjbillch.project          =    pjbill.project
and      pjbillch.project          =    pjproj.project
and      pjbillch.invoice_num      <>   @parm1
and      pjbill.biller             like @parm2
and      pjproj.gl_subacct         like @parm3
and      pjbillch.project       between @parm4beg and @parm4end
and      pjbillch.appnbr           =    @parm5
GO
