USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjexpaud_spk9]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjexpaud_spk9]  as
select * from
pjexpaud
Where zAUDIT_SEQ = 0
GO
