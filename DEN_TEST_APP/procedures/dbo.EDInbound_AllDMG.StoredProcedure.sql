USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInbound_AllDMG]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDInbound_All    Script Date: 5/28/99 1:17:42 PM ******/
CREATE Proc [dbo].[EDInbound_AllDMG] @Parm1 varchar(15), @Parm2 varchar(3) As Select * From EDInbound
Where Custid = @Parm1 And Trans Like @Parm2 Order By Custid, Trans
GO
