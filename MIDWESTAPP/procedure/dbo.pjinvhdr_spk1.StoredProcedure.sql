USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spk1]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_spk1] @parm1 varchar (16) , @parm2 varchar (10)  as
	select * from pjinvhdr where
		project_billwith = @parm1 AND
		draft_num Like @parm2
		order by Project_billwith, draft_num Desc
GO
