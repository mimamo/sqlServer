USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjexpaud_spk9]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjexpaud_spk9]  as
select * from
pjexpaud
Where zAUDIT_SEQ = 0
GO
