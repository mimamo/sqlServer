USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_10550_Return]    Script Date: 12/21/2015 13:57:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[pp_10550_Return]
            @UserAddress VARCHAR (21) As       -- ComputerName
-- Purge Work Records
    SELECT * FROM IN10550_Return
          WHERE ComputerName = @UserAddress
GO
