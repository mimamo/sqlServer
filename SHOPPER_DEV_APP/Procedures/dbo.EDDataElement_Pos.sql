USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Pos]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_Pos] @Parm1 Varchar (5), @Parm2 Varchar(2) As
	Select distinct Position from EDDataElement WHERE Segment = @Parm1 AND Position LIKE @Parm2 order by Position
GO
