USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Seg]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_Seg] @Parm1 Varchar (5) As
	Select distinct Segment from EDDataElement WHERE Segment LIKE @Parm1 order by segment
GO
