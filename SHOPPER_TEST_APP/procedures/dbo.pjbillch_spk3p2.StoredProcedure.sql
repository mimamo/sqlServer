USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjbillch_spk3p2]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjbillch_spk3p2] @parm1 varchar (10) , @parm2 varchar (10) , @parm3 varchar (24) , @parm4beg varchar (16) , @parm4end varchar (16)  as
select COUNT(*) from pjbillch, pjbill, pjproj
where    pjbillch.project          =    pjbill.project
and      pjbillch.project          =    pjproj.project
and      pjbillch.invoice_num      =    @parm1
and      pjbill.biller             like @parm2
and      pjproj.gl_subacct         like @parm3
and      pjbillch.project       between @parm4beg and @parm4end
GO
