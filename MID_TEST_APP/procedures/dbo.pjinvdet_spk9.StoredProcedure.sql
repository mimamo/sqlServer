USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_spk9]    Script Date: 12/21/2015 15:49:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_spk9]  as
select * from
pjinvdet
Where SOURCE_TRX_ID = 0
GO
