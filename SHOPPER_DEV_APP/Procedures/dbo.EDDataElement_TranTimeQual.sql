USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_TranTimeQual]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_TranTimeQual]  @Parm1 varchar(15) As Select  * From EDDataElement
Where Segment = 'TD' And Position = '510' And Code Like @Parm1
Order By Segment, Position, Code
GO
