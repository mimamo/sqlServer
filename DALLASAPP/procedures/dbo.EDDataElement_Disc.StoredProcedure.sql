USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Disc]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDataElement_Disc] @Code varchar(5) AS
Select * From EDDataElement Where ((Segment = 'ITA' And Position = '02') Or (Segment = 'SAC' And Position = '02')) And Code Like @Code
GO
