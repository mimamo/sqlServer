USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Seg]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_Seg] @Parm1 Varchar (5) As
	Select distinct Segment from EDDataElement WHERE Segment LIKE @Parm1 order by segment
GO
