USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPackIndicator_ItemAndGlobal]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDPackIndicator_ItemAndGlobal] @InvtId varchar(30) As
Select PackIndicator, Description From EDPackIndicator Where InvtId = @InvtId Or
(InvtId = '*' And PackIndicator Not In (Select PackIndicator From EDPackIndicator Where
InvtId = @InvtId))
GO
