import { spawn, execSync } from 'child_process';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

console.log('🔧 Preparing Python components for Windows build...');

// Get the current working directory
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.dirname(__dirname);

console.log(`📁 Project root: ${projectRoot}`);
console.log(`📁 Python directory: ${path.join(projectRoot, 'python')}`);

// Check if Python directory exists
const pythonDir = path.join(projectRoot, 'python');
if (!fs.existsSync(pythonDir)) {
    console.error('❌ Python directory not found!');
    process.exit(1);
}

// Check if virtual environment exists
const venvPath = path.join(pythonDir, 'venv');
if (!fs.existsSync(venvPath)) {
    console.log('⚠️  Virtual environment not found. Setting up Python environment...');

    // Run setup script
    try {
        console.log('🏃 Running Python setup...');
        execSync('python/setup.bat', {
            cwd: projectRoot,
            stdio: 'inherit'
        });
        console.log('✅ Python setup completed');
    } catch (error) {
        console.error('❌ Failed to setup Python environment:', error.message);
        process.exit(1);
    }
} else {
    console.log('✅ Virtual environment found');
}

// Build the Python binary
try {
    console.log('🏗️  Building Python binary...');
    execSync('python/build_and_install.bat', {
        cwd: projectRoot,
        stdio: 'inherit'
    });
    console.log('✅ Python binary built successfully');
} catch (error) {
    console.error('❌ Failed to build Python binary:', error.message);
    process.exit(1);
}

// Verify the binary was created
const binaryPath = path.join(pythonDir, 'dist', 'blink_detector.exe');
if (!fs.existsSync(binaryPath)) {
    console.error('❌ Binary not found at expected location:', binaryPath);
    process.exit(1);
}

console.log('✅ Binary verified at:', binaryPath);

// Check binary size
const stats = fs.statSync(binaryPath);
const sizeInMB = (stats.size / (1024 * 1024)).toFixed(2);
console.log(`📊 Binary size: ${sizeInMB} MB`);

// Verify Electron resources directory
const electronResourcesDir = path.join(projectRoot, 'electron', 'resources');
if (!fs.existsSync(electronResourcesDir)) {
    console.log('📁 Creating Electron resources directory...');
    fs.mkdirSync(electronResourcesDir, { recursive: true });
}

console.log('✅ Python preparation completed successfully!');
console.log('🚀 Ready for Electron build...');
