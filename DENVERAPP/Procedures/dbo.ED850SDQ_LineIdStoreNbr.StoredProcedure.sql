USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_LineIdStoreNbr]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850SDQ_LineIdStoreNbr] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @StoreNbr varchar(17) As
Select * From ED850SDQ Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId And StoreNbr = @StoreNbr
GO
