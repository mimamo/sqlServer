USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_spk7]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_spk7] @parm1 varchar (10)  as
select * from PJINVDET
where pjinvdet.draft_num =      @parm1
and li_type in ( 'T', 'R' )
GO
