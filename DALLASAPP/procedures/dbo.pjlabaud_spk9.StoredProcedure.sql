USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjlabaud_spk9]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjlabaud_spk9]  as
select * from
pjlabaud
Where zAUDIT_SEQ = 0
GO
