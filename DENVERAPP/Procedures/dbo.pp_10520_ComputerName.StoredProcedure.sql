USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pp_10520_ComputerName]    Script Date: 12/21/2015 15:43:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[pp_10520_ComputerName]
            @Parm1 VARCHAR (21) As       -- ComputerName
-- Purge Work Records
    SELECT * FROM IN10520_Wrk
          WHERE ComputerName = @Parm1
GO
