USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjlabaud_spk9]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjlabaud_spk9]  as
select * from
pjlabaud
Where zAUDIT_SEQ = 0
GO
