USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_10530_ComputerName]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[pp_10530_ComputerName]
            @UserAddress VARCHAR (21) As       -- ComputerName
-- Purge Work Records
    Select * FROM IN10530_Wrk
          WHERE ComputerName = @UserAddress
GO
