USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_TranDirCode]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_TranDirCode]  @Parm1 varchar(15) As Select  * From EDDataElement
Where Segment = 'TD' And Position = '509' And Code Like @Parm1
Order By Segment, Position, Code
GO
