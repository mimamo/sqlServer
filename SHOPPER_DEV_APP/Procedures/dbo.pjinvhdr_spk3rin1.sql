USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spk3rin1]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_spk3rin1] @parm1 varchar (10) , @parm2 varchar (10) , @parm3 varchar (24) , @parm4 varchar (10) , @parm5beg varchar (10) , @parm5end varchar (10)  as
select * from pjinvhdr, pjbill, pjproj
where    pjinvhdr.project_billwith =    pjbill.project
and      pjinvhdr.project_billwith =    pjproj.project
and      pjinvhdr.doctype = 'IN'
and      pjinvhdr.invoice_num      <>   @parm1
and      pjbill.biller             like @parm2
and      pjproj.gl_subacct         like @parm3
and      pjinvhdr.cpnyid           =    @parm4
and      pjinvhdr.invoice_num   between @parm5beg and @parm5end
order by pjinvhdr.invoice_num
GO
