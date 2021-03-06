USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spk3rinv]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_spk3rinv] @parm1 varchar (10) , @parm2 varchar (10) , @parm3 varchar (24) , @parm4 varchar (10)  , @parm5 varchar (10)  as
select * from pjinvhdr, pjbill, pjproj
where    pjinvhdr.project_billwith =    pjbill.project
and      pjinvhdr.project_billwith =    pjproj.project
and      pjinvhdr.doctype = 'IN'
and      pjinvhdr.invoice_num      <>   @parm1
and      pjbill.biller             like @parm2
and      pjproj.gl_subacct         like @parm3
and      pjinvhdr.cpnyid           like @parm4
and      pjinvhdr.invoice_num      like @parm5
order by pjinvhdr.invoice_num DESC
GO
