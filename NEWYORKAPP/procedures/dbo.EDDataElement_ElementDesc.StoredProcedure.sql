USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_ElementDesc]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDataElement_ElementDesc] @Code varchar(5) AS
Select Code, Description From EDDataElement Where ((Segment = 'ITA' And Position = '02') Or (Segment = 'SAC' And Position = '04')) And Code Like @Code
GO
