USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_RoutingSeqCode]    Script Date: 12/21/2015 15:49:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_RoutingSeqCode]  @Parm1 varchar(15) As Select  * From EDDataElement
Where Segment = 'TD' And Position = '501' And Code Like @Parm1
Order By Segment, Position, Code
GO
