USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spk0]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_spk0] @parm1 varchar (10)  as
select * from pjinvhdr where draft_num = @parm1
order by draft_num
GO
