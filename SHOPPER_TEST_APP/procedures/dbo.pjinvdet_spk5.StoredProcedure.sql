USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_spk5]    Script Date: 12/21/2015 16:07:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_spk5] @parm1 varchar (16), @parm2 varchar (10) as
select * from PJINVDET
where
pjinvdet.Project_Billwith = @parm1 and
pjinvdet.draft_num =      @parm2
and li_type = 'T'
GO
