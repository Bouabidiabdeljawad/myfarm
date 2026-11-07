package com.myfarm.auth.service;

import com.myfarm.auth.dto.*;
import com.myfarm.auth.model.User;
import com.myfarm.auth.repository.UserRepository;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;
import org.xhtmlrenderer.pdf.ITextRenderer;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

@Service
public class MemberReportService {

    private final MemberDashboardService memberDashboardService;
    private final UserRepository userRepository;
    private final TemplateEngine templateEngine;

    public MemberReportService(MemberDashboardService memberDashboardService, UserRepository userRepository) {
        this.memberDashboardService = memberDashboardService;
        this.userRepository = userRepository;
        this.templateEngine = createTemplateEngine();
    }

    /**
     * Generate a PDF report for a member for a specific period (month).
     *
     * @param memberId the ID of the member
     * @param period the period in format "yyyy-MM" (e.g., "2024-01")
     * @return PDF as byte array
     */
    public byte[] generateMemberReport(Long memberId, String period) {
        // Parse period (yyyy-MM)
        YearMonth yearMonth = YearMonth.parse(period, DateTimeFormatter.ofPattern("yyyy-MM"));
        LocalDate start = yearMonth.atDay(1);
        LocalDate end = yearMonth.atEndOfMonth();

        // Fetch dashboard data
        MemberDashboardDto dashboard = memberDashboardService.getMemberDashboard(memberId, start, end);

        // Fetch member info
        User user = userRepository.findById(memberId).orElse(null);

        // Prepare template context
        Context context = new Context(Locale.getDefault());
        context.setVariable("member", user);
        context.setVariable("dashboard", dashboard);
        context.setVariable("period", period);
        context.setVariable("startDate", start.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        context.setVariable("endDate", end.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        context.setVariable("generationDate", LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));

        // Render HTML
        String html = templateEngine.process("member-report", context);

        // Convert to PDF
        return htmlToPdf(html);
    }

    private TemplateEngine createTemplateEngine() {
        TemplateEngine engine = new TemplateEngine();
        ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
        resolver.setPrefix("templates/");
        resolver.setSuffix(".html");
        resolver.setTemplateMode(TemplateMode.HTML);
        resolver.setCharacterEncoding("UTF-8");
        resolver.setCacheable(false);
        engine.setTemplateResolver(resolver);
        return engine;
    }

    private byte[] htmlToPdf(String html) {
        try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
            ITextRenderer renderer = new ITextRenderer();
            renderer.setDocumentFromString(html);
            renderer.layout();
            renderer.createPDF(outputStream);
            return outputStream.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate PDF", e);
        }
    }
}