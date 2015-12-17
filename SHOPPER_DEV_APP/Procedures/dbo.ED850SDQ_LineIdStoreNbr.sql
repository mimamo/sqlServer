USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_LineIdStoreNbr]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850SDQ_LineIdStoreNbr] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @StoreNbr varchar(17) As
Select * From ED850SDQ Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId And StoreNbr = @StoreNbr
GO
