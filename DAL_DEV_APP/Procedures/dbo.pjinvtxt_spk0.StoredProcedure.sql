USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvtxt_spk0]    Script Date: 12/21/2015 13:35:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvtxt_spk0] @parm1 varchar (10)  as
select * from  pjinvtxt where
draft_num = @parm1 AND
text_type = 'I'
order by draft_num, text_type, project
GO
