USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_FOBShip]    Script Date: 12/21/2015 15:49:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[EDDataElement_FOBShip] @Parm1 varchar(15) As Select  * From EDDataElement
Where Segment = 'FOB' And Position = '01' And Code Like @Parm1
Order By Segment, Position, Code
GO
