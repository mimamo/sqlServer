USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCashIntegrityCheck]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DeleteCashIntegrityCheck]
       @acct varchar (10), @sub varchar (24), @cpnyid varchar (10),
       @prevdate  smalldatetime, @prevper varchar (6),  @trandate smalldatetime,
       @perpost varchar (6), @fiscyr varchar (4)
AS

DELETE FROM CashSumD

WHERE
                     BankAcct LIKE @acct AND
                     BankSub LIKE @sub AND
                     CpnyID LIKE @cpnyid  AND
                    (TranDate = @prevdate AND PerNbr > @prevper OR TranDate > @prevdate) AND
                    (TranDate < @trandate OR TranDate = @trandate AND PerNbr < @perpost) AND
                     substring (PerNbr, 1, 4)  >= @FiscYr
GO
