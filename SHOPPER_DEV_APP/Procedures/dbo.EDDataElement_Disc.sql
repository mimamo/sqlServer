USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Disc]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDataElement_Disc] @Code varchar(5) AS
Select * From EDDataElement Where ((Segment = 'ITA' And Position = '02') Or (Segment = 'SAC' And Position = '02')) And Code Like @Code
GO
