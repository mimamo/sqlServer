USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_TranMethCode]    Script Date: 12/21/2015 13:35:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_TranMethCode]  @Parm1 varchar(15) As Select  * From EDDataElement
Where Segment = 'TD' And Position = '504' And Code Like @Parm1
Order By Segment, Position, Code
GO
