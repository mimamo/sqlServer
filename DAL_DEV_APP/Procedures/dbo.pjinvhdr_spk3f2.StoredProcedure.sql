USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spk3f2]    Script Date: 12/21/2015 13:35:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_spk3f2] @parm1 varchar (2) , @parm2 varchar (10) , @parm3 varchar (24), @parm4 varchar (10)  , @parm5beg varchar (10) , @parm5end varchar (10)  as
select COUNT(*) from pjinvhdr, pjbill, pjproj
where    pjinvhdr.project_billwith =    pjbill.project
and      pjinvhdr.project_billwith =    pjproj.project
and      pjinvhdr.doctype = 'IN'
and      pjinvhdr.inv_status       =    @parm1
and      pjbill.biller             like @parm2
and      pjproj.gl_subacct         like @parm3
and      pjinvhdr.cpnyid           =    @parm4
and      pjinvhdr.draft_num     between @parm5beg and @parm5end
GO
