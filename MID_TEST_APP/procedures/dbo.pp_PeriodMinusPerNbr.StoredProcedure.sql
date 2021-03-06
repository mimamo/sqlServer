USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_PeriodMinusPerNbr]    Script Date: 12/21/2015 15:49:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[pp_PeriodMinusPerNbr] @period VarChar(6), @PerToSub INT, @OutPerNbr VarChar(6) OUTPUT
AS
DECLARE @NumPerNbr INT, @NumYr INT, @WholeYr INT, @Remain INT
    SET @NumYR = CONVERT(INT,SUBSTRING(@Period,1,4))
    SET @NumPerNbr = CONVERT(INT,SUBSTRING(@Period,5,2))

SELECT @WholeYr = CONVERT(INT,@PerToSub / NbrPer) ,@Remain =  @PerToSub % NbrPer  FROM GLSETUP (NOLOCK)

IF @Remain >= @NumPerNbr
   BEGIN
      SELECT @NumYr = @NumYr - @WholeYr - 1
      SELECT @NumPerNbr = @NumPerNbr + NbrPer - @Remain
        FROM GLSETUP (NOLOCK)
   END
ELSE
   BEGIN
      SELECT @NumPerNbr = @NumPerNbr - @Remain
      SELECT @NumYr     = @NumYr     - @WholeYr
   END

SELECT @OutPerNbr = CONVERT(VARCHAR(6),(@NumYr*100 + @NumPerNbr))
GO
